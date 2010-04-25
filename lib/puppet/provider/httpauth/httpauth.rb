begin
    require 'webrick'
rescue
    Puppet.warning "You need WEBrick installed to manage HTTP Authentication files."
end

Puppet::Type.type(:httpauth).provide(:httpauth) do
    desc "Manage HTTP Basic and Digest authentication files"

    def create
        @htauth.set_passwd(resource[:realm], resource[:name], resource[:password])
        @htauth.flush 
    end
 
    def destroy
        @htauth.delete_passwd(resource[:realm], resource[:name])
        @htauth.flush
    end
 
    def exists?
        if File.exists?(resource[:file])
            mech(resource[:file])
            
            cp = @htauth.get_passwd(resource[:realm], resource[:name], false)
           
            if cp == make_passwd(resource[:realm], resource[:name], resource[:password])
                return true
            else
                return false
            end
        else
            File.new(resource[:file], "w")
            mech(resource[:file])
            return false
        end
    end

    def mech(file)
        if resource[:mechanism] == :digest 
            @htauth = WEBrick::HTTPAuth::Htdigest.new(file)
        elsif resource[:mechanism] == :basic
            @htauth = WEBrick::HTTPAuth::Htpasswd.new(file)
        end
    end

    def make_passwd(realm, user, password)
        if resource[:mechanism] == :digest
            WEBrick::HTTPAuth::DigestAuth.make_passwd(realm, user, password)
        elsif resource[:mechanism] == :basic
            WEBrick::HTTPAuth::BasicAuth.make_passwd(realm, user, password)
        end
    end
end
