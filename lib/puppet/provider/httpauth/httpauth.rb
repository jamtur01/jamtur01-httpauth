begin
    require 'webrick'
rescue
    Puppet.warning "You need WEBrick installed to manage HTTP Authentication files."
end

Puppet::Type.type(:httpauth).provide(:httpauth) do
    desc "Manage HTTP Basic and Digest authentication files"

    def create
        # Create a user in the file we opened in the mech method
        @htauth.set_passwd(resource[:realm], resource[:name], resource[:password])
        @htauth.flush 
    end
 
    def destroy
        # Delete a user in the file we opened in the mech method
        @htauth.delete_passwd(resource[:realm], resource[:name])
        @htauth.flush
    end
 
    def exists?
        # Check if the file exists at all
        if File.exists?(resource[:file])
            # If it does exist open the file
            mech(resource[:file])

            # Check if the user exists in the file
            cp = @htauth.get_passwd(resource[:realm], resource[:name], false)
            return false if cp == nil
            # Check if the current password matches the proposed password
            return check_passwd(resource[:realm], resource[:name], resource[:password], cp)
        else
            # If the file doesn't exist then create it
            File.new(resource[:file], "w")
            mech(resource[:file])
            return false
        end
    end

    # Open the password file
    def mech(file)
        if resource[:mechanism] == :digest 
            @htauth = WEBrick::HTTPAuth::Htdigest.new(file)
        elsif resource[:mechanism] == :basic
            @htauth = WEBrick::HTTPAuth::Htpasswd.new(file)
        end
    end

    # Check password matches
    def check_passwd(realm, user, password, cp)
        if resource[:mechanism] == :digest
            WEBrick::HTTPAuth::DigestAuth.make_passwd(realm, user, password) == cp
        elsif resource[:mechanism] == :basic
            # Can't ask webbrick as it uses a random seed
            password.crypt(cp[0,2]) == cp
        end
    end
end
