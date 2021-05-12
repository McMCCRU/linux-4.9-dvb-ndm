#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <generated/utsrelease.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Igor Mokrushin aka McMCC");
MODULE_DESCRIPTION("Linux module.");
MODULE_VERSION("Additional drivers for kernel Linux version " UTS_RELEASE "_" __TIMESTAMPZ__);

static int __init compat_init(void) {
	printk(KERN_INFO "Hello, World!\n");
	return 0;
}

static void __exit compat_exit(void) {
	printk(KERN_INFO "Goodbye, World!\n");
}

module_init(compat_init);
module_exit(compat_exit);
