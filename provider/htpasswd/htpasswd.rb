begin
    require 'webrick'
rescue

end

Puppet::Type.type(:htpasswd).provide(:htpasswd) do
    desc "Manage HTTP Basic authentication files"

    def create
        htpd = WEBrick::HTTPAuth::Htpasswd.new(resource[:file])
        realm = nil
        htpd.set_passwd(realm, resource[:name], resource[:password])
        htpd.flush 
    end
 
    def destroy
        htpd = WEBrick::HTTPAuth::Htpasswd.new(resource[:file])
        realm = nil
        htpd.delete_passwd(realm, resource[:name])
        htpd.flush
    end
 
    def exists?
        if File.exists?(resource[:file])
            htpd = WEBrick::HTTPAuth::Htpasswd.new(resource[:file])
            realm = nil
            htpd.get_passwd(realm, resource[:name], false)
        else
            File.new(resource[:file], "w")
            false
        end
    end
end
