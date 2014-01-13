Vagrant Swift
-------------

The intent of this project is to allow developers to provision an openstack swift and ceilometer endpoint using [vagrant](http://vagrantup.com) and [devstack](http://devstack.org).

Usage
=====

Launching The VM
================

In order to launch the VM follow the instructions bellow:

Clone this repository:
```shell
git clone git@github.com:JamesAwesome/vagrant-swift.git
```

Run Vagrant:
```shell
vagrant up
```

Verifying the installation
==========================

1) Log into your VM via vagrant and source "./devstack/openrc". This will set up the proper envvars for using devstack with it's automatically created "demo" account.
```shell
vagrant ssh
source ./devstack/openrc
```

2) Create a test container and upload files to swift. ***NOTE*** Without this step ceilometer will not have any metrics to report and thusly cannot be verified.
```shell
swift upload test_container /home/vagrant
```

3) Verify ceilometer
```shell
ceilometer meter-list
```

If ceilometer is functioning correctly you should see output similar to (but not identical to) the following:

```
+--------------------------------+-------+-----------+----------------------------------+----------------------------------+----------------------------------+
| Name                           | Type  | Unit      | Resource ID                      | User ID                          | Project ID                       |
+--------------------------------+-------+-----------+----------------------------------+----------------------------------+----------------------------------+
| storage.api.request            | delta | request   | afff72bf340e4ec0b16a52a58d2d2937 | 4854ad323b4647bf812d6fc2beb6f12f | afff72bf340e4ec0b16a52a58d2d2937 |
| storage.objects                | gauge | object    | afff72bf340e4ec0b16a52a58d2d2937 | 4854ad323b4647bf812d6fc2beb6f12f | afff72bf340e4ec0b16a52a58d2d2937 |
| storage.objects.containers     | gauge | container | afff72bf340e4ec0b16a52a58d2d2937 | 4854ad323b4647bf812d6fc2beb6f12f | afff72bf340e4ec0b16a52a58d2d2937 |
| storage.objects.incoming.bytes | delta | B         | afff72bf340e4ec0b16a52a58d2d2937 | 4854ad323b4647bf812d6fc2beb6f12f | afff72bf340e4ec0b16a52a58d2d2937 |
| storage.objects.size           | gauge | B         | afff72bf340e4ec0b16a52a58d2d2937 | 4854ad323b4647bf812d6fc2beb6f12f | afff72bf340e4ec0b16a52a58d2d2937 |
+--------------------------------+-------+-----------+----------------------------------+----------------------------------+----------------------------------+
```

If you do not see similar output please ensure you followed the instructions in step two.
