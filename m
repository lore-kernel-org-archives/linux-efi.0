From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/27] Add a SysRq option to lift kernel lockdown
Date: Tue, 07 Nov 2017 15:39:06 -0200
Message-ID: <877ev2rnt1.fsf@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842464774.7923.7951986297563109339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <150842464774.7923.7951986297563109339.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org


Hello David,

David Howells <dhowells@redhat.com> writes:
> +static struct sysrq_key_op lockdown_lift_sysrq_op = {
> +	.handler	= sysrq_handle_lockdown_lift,
> +	.help_msg	= "unSB(x)",
> +	.action_msg	= "Disabling Secure Boot restrictions",
> +	.enable_mask	= SYSRQ_DISABLE_USERSPACE,
> +};
> +
> +static int __init lockdown_lift_sysrq(void)
> +{
> +	if (kernel_locked_down) {
> +		lockdown_lift_sysrq_op.help_msg[5] = LOCKDOWN_LIFT_KEY;
> +		register_sysrq_key(LOCKDOWN_LIFT_KEY, &lockdown_lift_sysrq_op);
> +	}
> +	return 0;
> +}
> +
> +late_initcall(lockdown_lift_sysrq);
> +
> +#endif /* CONFIG_ALLOW_LOCKDOWN_LIFT_BY_KEY */

On non-x86 platforms (tested on powerpc) this fails to build with:

security/lock_down.c: In function ‘lockdown_lift_sysrq’:
security/lock_down.c:100:40: error: ‘LOCKDOWN_LIFT_KEY’ undeclared (first use in this function)
   lockdown_lift_sysrq_op.help_msg[5] = LOCKDOWN_LIFT_KEY;
                                        ^~~~~~~~~~~~~~~~~
security/lock_down.c:100:40: note: each undeclared identifier is reported only once for each function it appears in

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
