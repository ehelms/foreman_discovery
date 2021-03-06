module Foreman::Controller::DiscoveredExtensions
  extend ActiveSupport::Concern

  # return auto provision rule or false when not present
  def find_discovery_rule host
    Rails.logger.debug "Finding auto discovery rule for host #{host.name} (#{host.id})"
    # for each discovery rule ordered by priority
    DiscoveryRule.where(:enabled => true).order(:priority).each do |rule|
      max = rule.max_count
      usage = rule.hosts.size
      Rails.logger.debug "Found rule #{rule.name} (#{rule.id}) [#{usage}/#{max}]"
      # if the rule has free slots
      if max == 0 || usage < max
        # try to match the search
        begin
          if Host::Discovered.where(:id => host.id).search_for(rule.search).size > 0
            if rule.organizations.include?(host.organization) && rule.locations.include?(host.location)
              Rails.logger.info "Match found for host #{host.name} (#{host.id}) rule #{rule.name} (#{rule.id})"
              return rule
            else
              Rails.logger.warn "Rule #{rule.name} (#{rule.id}) can not be applied due to a difference in organization/location from host #{host.name} (#{host.id})"
            end
          end
        rescue ScopedSearch::QueryNotSupported => e
          Rails.logger.warn "Invalid query for rule #{rule.name} (#{rule.id}): #{e.message}"
        end
      else
        Rails.logger.info "Skipping drained rule #{rule.name} (#{rule.id}) with max set to #{rule.max_count}"
      end
    end
    return false
  end

  # trigger the provisioning
  def perform_auto_provision original_host, rule
    Host.transaction do
      host = ::ForemanDiscovery::HostConverter.to_managed(original_host)
      host.hostgroup_id = rule.hostgroup_id
      host.comment = "Auto-discovered and provisioned via rule '#{rule.name}'"
      host.discovery_rule = rule
      # render hostname only when all other fields are set
      original_name = host.name
      host.name = host.render_template(rule.hostname) unless rule.hostname.empty?
      # fallback to the original if template did not expand
      host.name = original_name if host.name.empty?
      # save! does not work here
      host.save
    end
  end


end
