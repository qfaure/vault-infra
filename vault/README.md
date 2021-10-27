# Create a Vault HA cluster on AWS using Terraform

These assets are provided to perform the tasks described in the [Vault HA Cluster with Integrated Storage on AWS](https://learn.hashicorp.com/vault/operations/raft-storage-aws) guide.

---

1.  Set your AWS credentials as environment variables:

    ```plaintext
    $ export AWS_ACCESS_KEY_ID = "<YOUR_AWS_ACCESS_KEY_ID>"
    $ export AWS_SECRET_ACCESS_KEY = "<YOUR_AWS_SECRET_ACCESS_KEY>"
    ```

1.  Repository structure :

Config folder will contain variable: 
>  Files are evaluated/overriden into this order (the later takes predecence):
> 0. Inputs defined in this file (main terragrunt.hcl)
> 1. /config/common.vars.yml
> 2. /config/**/common.vars.yml
> 3. /config/<TF_VAR_ENV>.vars.yml
> 4. /config/**/<TF_VAR_ENV>.vars.yml

stacks folder will contain terraform code.
```
└── terraform
    ├── config   
    │   ├── sample
    │   │   └── common.vars.yml
    │   │   └── dev.vars.yml
    │   │   └── stage1.vars.yml
    │   │   └── stage2.vars.yml
    │   │   └── prod.vars.yml
    │   │   └── terragrunt.hcl
    │   └── terragrunt.hcl
    │   └── common.vars.yml
    ├── stacks
    │   ├── sample
    │   │   └── data.tf
    │   │   └── provider.tf
    │   │   └── locals.tf
    │   │   └── variables.tf
    │   │   └── samples.tf
    └── empty.yml
└── jenkinsfile

```

1.  Run Terraform commands to provision your cloud resources:

    ```plaintext
    $ terragrunt run-all plan

    $ terragrunt run-all apply

    ```

    The Terraform output will display the IP addresses of the provisioned Vault nodes.

    ```plaintext
    vault_transit (x.x.x.x)  | internal: (10.0.101.21)
    leader (x.x.x.x) | internal: (10.0.101.22)
      # Root token:
      $ ssh -l ubuntu x.x.x.x -i <path/to/key.pem> "cat ~/root_token"
      # Recovery key:
      $ ssh -l ubuntu x.x.x.x -i <path/to/key.pem> "cat ~/recovery_key"

    vault_2 (x.x.x.x) | internal: (10.0.101.23)
      $ ssh -l ubuntu x.x.x.x -i <path/to/key.pem>

    vault_3 (x.x.x.x) | internal: (10.0.101.24)
      $ ssh -l ubuntu x.x.x.x -i <path/to/key.pem>
    ```

1.  SSH into **leader**.

    ```sh
    ssh -l ubuntu x.x.x.x -i <path/to/key.pem>
        vault operator raft list-peers
    ```

1.  Check the current number of servers in the HA Cluster.

    ```plaintext
    $ VAULT_TOKEN=$(cat /tmp/key.json | jq -r ".root_token") vault operator raft list-peers
    Node       Address             State     Voter
    ----       -------             -----     -----
    leader    10.0.101.22:8201    leader    true
    vault_2   10.0.102.23:8201    follower  true
    vault_3   10.0.103.24:8201    follower  true
    ```

