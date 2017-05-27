From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 5/5] Add a sysrq option to exit secure boot mode
Date: Sat, 27 May 2017 12:06:54 +0800
Message-ID: <20170527040654.GG15587@linux-l9pv.suse>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <149563716341.9419.12043461651917925181.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149563716341.9419.12043461651917925181.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

On Wed, May 24, 2017 at 03:46:03PM +0100, David Howells wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Make sysrq+x exit secure boot mode on x86_64, thereby allowing the running
> kernel image to be modified.  This lifts the lockdown.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: x86@kernel.org
> ---
> 
>  arch/x86/include/asm/efi.h        |    2 ++
>  drivers/firmware/efi/Kconfig      |   10 ++++++++++
>  drivers/firmware/efi/secureboot.c |   37 +++++++++++++++++++++++++++++++++++++
>  drivers/input/misc/uinput.c       |    1 +
>  drivers/tty/sysrq.c               |   19 +++++++++++++------
>  include/linux/input.h             |    5 +++++
>  include/linux/sysrq.h             |    8 +++++++-
>  kernel/debug/kdb/kdb_main.c       |    2 +-
>  8 files changed, 76 insertions(+), 8 deletions(-)
> 
[...snip]  
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index 3ffc1ce29023..8b766dbad6dd 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -481,6 +481,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	/* x: May be registered on mips for TLB dump */
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	/* x: May be registered on sparc64 for global PMU dump */
> +	/* x: May be registered on x86_64 for disabling secure boot */
>  	NULL,				/* x */

I suggest that add this key to the "What are the 'command' keys?"
session in Documentation/admin-guide/sysrq.rst.

>  	/* y: May be registered on sparc64 for global register dump */
>  	NULL,				/* y */
> @@ -524,7 +525,7 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
>                  sysrq_key_table[i] = op_p;
>  }
>  
> -void __handle_sysrq(int key, bool check_mask)
> +void __handle_sysrq(int key, unsigned int from)
>  {
>  	struct sysrq_key_op *op_p;
>  	int orig_log_level;
> @@ -544,11 +545,15 @@ void __handle_sysrq(int key, bool check_mask)
>  
>          op_p = __sysrq_get_key_op(key);
>          if (op_p) {
> +		/* Ban synthetic events from some sysrq functionality */
> +		if ((from == SYSRQ_FROM_PROC || from == SYSRQ_FROM_SYNTHETIC) &&
> +		    op_p->enable_mask & SYSRQ_DISABLE_USERSPACE)
> +			printk("This sysrq operation is disabled from userspace.\n");
>  		/*
>  		 * Should we check for enabled operations (/proc/sysrq-trigger
>  		 * should not) and is the invoked operation enabled?
>  		 */
> -		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
> +		if (from == SYSRQ_FROM_KERNEL || sysrq_on_mask(op_p->enable_mask)) {
>  			pr_cont("%s\n", op_p->action_msg);
>  			console_loglevel = orig_log_level;
>  			op_p->handler(key);

Looking at sysrq_on_mask():

static bool sysrq_on_mask(int mask)
{
	return sysrq_always_enabled ||
	       sysrq_enabled == 1 ||
	       (sysrq_enabled & mask); 
}

The SYSRQ_DISABLE_USERSPACE can be ignored by sysrq_always_enabled or
sysrq_enabled (the default value is CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1).
Kernel should checks the locked down flag here when secure boot ON. Will we
have another lock down patch against this? Or I missed something?

Thanks a lot!
Joey Lee
