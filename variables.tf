variable "instance_configs" {
    type = map(object({
        ami = string
        instance_type = string
        name = string
        public_key_path = string
    }))
    default = {
        "redhat-server" = {
            ami = "ami-0ad50334604831820" # redhat server
            instance_type = "t3.micro"
            name = "Redhat server"
            public_key_path = "~/.ssh/id_rsa.pub"
        },
        "ubuntu-server" = {
            ami = "ami-0b6c6ebed2801a5cb" # ubuntu server
            instance_type = "t3.micro"
            name = "ubuntu server"
            public_key_path = "~/.ssh/id_rsa.pub"
        }
    }
}
