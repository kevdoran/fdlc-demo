# FDLC Demo

This is a repository to demonstrate the GitPersistenceProvider that has been made available in NiFi Registry 0.2.0.

This repository was used as part of a presentation on FDLC with Apache NiFi at DataWorks Summit San Jose 2018. If you attended that session, welcome! I hope you found it and the materials in this repo useful. Feel free to reach out with any questions here or on twitter or on the NiFi mailing lists.

## Automation Scripts

There are two automation scripts that were demonstrated in the FDLC with Apache NiFi:

1. [deploy_flow_version.sh](deploy_flow_version.sh) - used to promote versions of a flow that are authored in a dev environment to staging and production environments

2. [copy_flow_to_registry2.sh](copy_flow_to_registry2.sh) - used to copy a flow version snapshot from one Registry to another

## Setup

I configured this through the following steps:

1. Go to the NiFi Registry 0.2.0 home directory (its install location, which has subdirectories such as `bin/`, `conf/`, and `lib/`), and clone this repository:

    ```
    cd /path/to/nifi-registry-0.2.0
    git clone git@github.com:kevdoran/fdlc-demo.git
    ```

    Note, this creates a directory `fdlc-demo/` in my NiFi Registry home directory with a clone on this github repo.

2. Configure `conf/providers.xml` as follows:

    ```
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <providers>
        <flowPersistenceProvider>
            <class>org.apache.nifi.registry.provider.flow.git.GitFlowPersistenceProvider</class>
            <property name="Flow Storage Directory">./fdlc-demo</property>
            <property name="Remote To Push">origin</property>
            
            <!-- These don't need to be configured when using ssh to interact with the remote repo
                 if you setup the machine/user running NiFi Registry with the proper ssh keys -->
            <property name="Remote Access User"></property>
            <property name="Remote Access Password"></property>
        </flowPersistenceProvider>
    </providers>
    ```

Note that I've configured my machine to connect to [Github using SSH](https://help.github.com/articles/connecting-to-github-with-ssh/), so my GitHub username and password are not required in my `conf/providers.xml` file. Alternatively, you can use https and provide your credentials.

