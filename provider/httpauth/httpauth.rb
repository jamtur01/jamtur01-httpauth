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
            @htauth.get_passwd(resource[:realm], resource[:name], false)
        else
            File.new(resource[:file], "w")
            mech(resource[:file])
            false
        end
    end

    def mech(file)
        if resource[:mechanism] == :digest 
            @htauth = WEBrick::HTTPAuth::Htdigest.new(file)
        elsif resource[:mechanism] == :basic
            @htauth = WEBrick::HTTPAuth::Htpasswd.new(file)
        end
    end
end
