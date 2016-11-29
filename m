From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Tue, 29 Nov 2016 14:03:31 +0000
Message-ID: <6973.1480428211@warthog.procyon.org.uk>
References: <2cd73312-c074-1367-6daa-710d11ac68f1@acm.org> <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk> <10164.1480378260@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <2cd73312-c074-1367-6daa-710d11ac68f1@acm.org>
Content-ID: <6972.1480428211.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: minyard@acm.org
Cc: dhowells@redhat.com, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

How about the attached?  Obviously it need extending to other drivers.

I thought that if I'm changing the module_param annotations anyway then it's
probably worth bunging in an extra parameter that notes what the parameter
modifies (ioport, iomem, etc.) for future reference, even if we don't store
it.

David
---
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7fb9c299a183..157e96391eca 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1375,39 +1375,39 @@ MODULE_PARM_DESC(type, "Defines the type of each interface, each"
 		 " interface separated by commas.  The types are 'kcs',"
 		 " 'smic', and 'bt'.  For example si_type=kcs,bt will set"
 		 " the first interface to kcs and the second to bt");
-module_param_array(addrs, ulong, &num_addrs, 0);
+module_param_hw_array(addrs, ulong, iomem, &num_addrs, 0);
 MODULE_PARM_DESC(addrs, "Sets the memory address of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " is in memory.  Otherwise, set it to zero or leave"
 		 " it blank.");
-module_param_array(ports, uint, &num_ports, 0);
+module_param_hw_array(ports, uint, ioport, &num_ports, 0);
 MODULE_PARM_DESC(ports, "Sets the port address of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " is a port.  Otherwise, set it to zero or leave"
 		 " it blank.");
-module_param_array(irqs, int, &num_irqs, 0);
+module_param_hw_array(irqs, int, irq, &num_irqs, 0);
 MODULE_PARM_DESC(irqs, "Sets the interrupt of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " has an interrupt.  Otherwise, set it to zero or leave"
 		 " it blank.");
-module_param_array(regspacings, int, &num_regspacings, 0);
+module_param_hw_array(regspacings, int, other, &num_regspacings, 0);
 MODULE_PARM_DESC(regspacings, "The number of bytes between the start address"
 		 " and each successive register used by the interface.  For"
 		 " instance, if the start address is 0xca2 and the spacing"
 		 " is 2, then the second address is at 0xca4.  Defaults"
 		 " to 1.");
-module_param_array(regsizes, int, &num_regsizes, 0);
+module_param_hw_array(regsizes, int, other, &num_regsizes, 0);
 MODULE_PARM_DESC(regsizes, "The size of the specific IPMI register in bytes."
 		 " This should generally be 1, 2, 4, or 8 for an 8-bit,"
 		 " 16-bit, 32-bit, or 64-bit register.  Use this if you"
 		 " the 8-bit IPMI register has to be read from a larger"
 		 " register.");
-module_param_array(regshifts, int, &num_regshifts, 0);
+module_param_hw_array(regshifts, int, other, &num_regshifts, 0);
 MODULE_PARM_DESC(regshifts, "The amount to shift the data read from the."
 		 " IPMI register, in bits.  For instance, if the data"
 		 " is read from a 32-bit word and the IPMI data is in"
 		 " bit 8-15, then the shift would be 8");
-module_param_array(slave_addrs, int, &num_slave_addrs, 0);
+module_param_hw_array(slave_addrs, int, other, &num_slave_addrs, 0);
 MODULE_PARM_DESC(slave_addrs, "Set the default IPMB slave address for"
 		 " the controller.  Normally this is 0x20, but can be"
 		 " overridden by this parm.  This is an array indexed"
@@ -3725,12 +3725,6 @@ static int init_ipmi_si(void)
 	struct smi_info *e;
 	enum ipmi_addr_src type = SI_INVALID;
 
-	if ((num_addrs || num_ports || num_irqs) &&
-	    kernel_is_locked_down()) {
-		pr_err(PFX "Kernel is locked down\n");
-		return -EPERM;
-	}
-
 	if (initialized)
 		return 0;
 	initialized = 1;
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 52666d90ca94..bdb884fba79a 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -60,9 +60,11 @@ struct kernel_param_ops {
  * Flags available for kernel_param
  *
  * UNSAFE - the parameter is dangerous and setting it will taint the kernel
+ * HWPARAM - Hardware param not permitted in lockdown mode
  */
 enum {
-	KERNEL_PARAM_FL_UNSAFE = (1 << 0)
+	KERNEL_PARAM_FL_UNSAFE	= (1 << 0),
+	KERNEL_PARAM_FL_HWPARAM	= (1 << 1),
 };
 
 struct kernel_param {
@@ -451,6 +453,62 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 			    perm, -1, 0);				\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
+enum hwparam_type {
+	hwparam_ioport,		/* Module parameter configures an I/O port */
+	hwparam_iomem,		/* Module parameter configures an I/O mem address */
+	hwparam_irq,		/* Module parameter configures an I/O port */
+	hwparam_dma,		/* Module parameter configures a DMA channel */
+	hwparam_dma_addr,	/* Module parameter configures a DMA buffer address */
+	hwparam_other,		/* Module parameter configures some other value */
+};
+
+/**
+ * module_param_hw - A parameter representing a hw parameters
+ * @name: a valid C identifier which is the parameter name.
+ * @type: the type of the parameter
+ * @hwtype: what the value represents (enum hwparam_type)
+ * @perm: visibility in sysfs.
+ *
+ * Usually it's a good idea to have variable names and user-exposed names the
+ * same, but that's harder if the variable must be non-static or is inside a
+ * structure.  This allows exposure under a different name.
+ */
+#define module_param_hw(name, type, hwtype, perm)			\
+	param_check_##type(name, &(name));				\
+	__module_param_call(MODULE_PARAM_PREFIX, name,			\
+			    &param_ops_##type, &name,			\
+			    perm, -1,					\
+			    KERNEL_PARAM_FL_HWPARAM | (hwparam_##hwtype & 0));	\
+	__MODULE_PARM_TYPE(name, #type)
+
+/**
+ * module_param_hw_array - A parameter representing an array of hw parameters
+ * @name: the name of the array variable
+ * @type: the type, as per module_param()
+ * @hwtype: what the value represents (enum hwparam_type)
+ * @nump: optional pointer filled in with the number written
+ * @perm: visibility in sysfs
+ *
+ * Input and output are as comma-separated values.  Commas inside values
+ * don't work properly (eg. an array of charp).
+ *
+ * ARRAY_SIZE(@name) is used to determine the number of elements in the
+ * array, so the definition must be visible.
+ */
+#define module_param_hw_array(name, type, hwtype, nump, perm)		\
+	param_check_##type(name, &(name)[0]);				\
+	static const struct kparam_array __param_arr_##name		\
+	= { .max = ARRAY_SIZE(name), .num = nump,			\
+	    .ops = &param_ops_##type,					\
+	    .elemsize = sizeof(name[0]), .elem = name };		\
+	__module_param_call(MODULE_PARAM_PREFIX, name,			\
+			    &param_array_ops,				\
+			    .arr = &__param_arr_##name,			\
+			    perm, -1,					\
+			    KERNEL_PARAM_FL_HWPARAM | (hwparam_##hwtype & 0));	\
+	__MODULE_PARM_TYPE(name, "array of " #type)
+
+
 extern const struct kernel_param_ops param_array_ops;
 
 extern const struct kernel_param_ops param_ops_string;
diff --git a/kernel/params.c b/kernel/params.c
index a6d6149c0fe6..2b68e6dad677 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -108,13 +108,20 @@ bool parameq(const char *a, const char *b)
 	return parameqn(a, b, strlen(a)+1);
 }
 
-static void param_check_unsafe(const struct kernel_param *kp)
+static bool param_check_unsafe(const struct kernel_param *kp,
+			       const char *doing)
 {
 	if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
 		pr_warn("Setting dangerous option %s - tainting kernel\n",
 			kp->name);
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 	}
+
+	if (kp->flags & KERNEL_PARAM_FL_HWPARAM && kernel_is_locked_down()) {
+		pr_err("Command line-specified device addresses, irqs and dma channels are not permitted when the kernel is locked down (%s.%s)\n", doing, kp->name);
+		return false;
+	}
+	return true;
 }
 
 static int parse_one(char *param,
@@ -144,8 +151,10 @@ static int parse_one(char *param,
 			pr_debug("handling %s with %p\n", param,
 				params[i].ops->set);
 			kernel_param_lock(params[i].mod);
-			param_check_unsafe(&params[i]);
-			err = params[i].ops->set(val, &params[i]);
+			if (param_check_unsafe(&params[i], doing))
+				err = params[i].ops->set(val, &params[i]);
+			else
+				err = -EPERM;
 			kernel_param_unlock(params[i].mod);
 			return err;
 		}
@@ -620,8 +629,10 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 		return -EPERM;
 
 	kernel_param_lock(mk->mod);
-	param_check_unsafe(attribute->param);
-	err = attribute->param->ops->set(buf, attribute->param);
+	if (param_check_unsafe(attribute->param, mk->mod->name))
+		err = attribute->param->ops->set(buf, attribute->param);
+	else
+		err = -EPERM;
 	kernel_param_unlock(mk->mod);
 	if (!err)
 		return len;
