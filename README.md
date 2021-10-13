# K3S Multiple-node Install using k3sup

+ Installing the `k3sup` remote installation program:
    
    - First, run `sudo ./k3sup-install.sh` to install k3sup locally

+ Pre-install Notes for preparing Raspberry Pi nodes, using Raspian:

    1. Usually the pi user has passwordless sudo access - if not, go ahead and enable that 
        - (you can disable it again after we've install our nodes, if you want to).

    2. Check the link below, from rancher.com regarding Raspbian Buster, and iptables.  You may need to run a few commands to modify iptables on your Pi.
        - https://rancher.com/docs/k3s/latest/en/advanced/#enabling-legacy-iptables-on-raspbian-buster

    3. Make sure the following values are set in /boot/cmdline.txt: `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1`
        - Reboot the pi if you have to add the above change.

+ Using `k3s-cluster-install.sh` to install k3s on multiple nodes

    1. Open up `k3s-cluster-install.sh` in your text editor, and look at the comment for the following variables, near the top:
        1. `remote_hosts` (this is a list of all the IP addresses you would like k3s installed on)
        2. `MAIN_NODE` (this is the IP address of the node which will be the main/master node)
        3. `REMOTE_USER` (this is the user which will be used to install k3s on each remote host

    2.  You will need ssh access to each IP address in `remote_hosts` as `REMOTE_USER` from the machine where you are peforming this installation.
        - `k3s-cluster-install.sh` will attempt to create/copy a new ecdsa ssh key to be used during the installation process (k3sup seems to not like rsa keys).

    3.  Once you have examined/modified `k3s-cluster-install.sh` to suite your site install needs, go ahead and run it in echo mode (e.g. make sure the line `echo=echo` at the top of the script is **NOT** commented out).
        - This should produce the list of commands that will be executed by `k3s-cluster-install.sh`

    4. If there are errors regarding an existing `~/.kube` or `~/.kube/config` or `$KUBECONFIG` - please modify your local environment accordingly (e.g `unset KUBECONFIG` and `mv ~/.kube ~/dot.kube` for this install)

    5. If there are no errors, and everything looks in order, comment out the echo=echo line near the top of `k3s-cluster-install.sh` and run again.

+ Checking on your cluster

   1. If everything went well, you should be able to run the following commands to get a view of your cluster status:

       - `export KUBECONFIG=~/.kube/config`

       - `kubectl -n kube-system get all`

       - `kubectl get nodes -o wide`

    2. You may want to set KUBECONFIG in your environment for future sessions too.
