Puppet::Type.newtype(:htpasswd) do
    @doc = "Manage HTTP basic password files"
 
    ensurable

    newparam(:name) do
       desc "The name of the user to be managed"

       isnamevar

    end 

    newparam(:file) do
       desc "The HTTP Basic password file to be managed"

    end

    newparam(:password) do
       desc "The password"
   
    end
end
