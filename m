From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/13] x86/efi: Build our own EFI services pointer table
Date: Thu, 27 Feb 2014 12:09:21 -0800
Message-ID: <530F9B71.1030405@zytor.com>
References: <1393530660-12692-1-git-send-email-matt@console-pimps.org> <1393530660-12692-7-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393530660-12692-7-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/27/2014 11:50 AM, Matt Fleming wrote:
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index a7677babf946..932e01c37550 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -19,10 +19,171 @@
>  
>  static efi_system_table_t *sys_table;
>  
> +static struct efi_config *efi_early;
> +
> +#define BOOT_SERVICES(bits)						\
> +static void setup_boot_services##bits(struct efi_config *c)		\
> +{									\
> +	u##bits table, *bt, *func;					\
> +	size_t off;							\
> +									\
> +	table = (typeof(table))(unsigned long)sys_table;		\
> +									\
> +	off = offsetof(efi_system_table_##bits##_t, con_out);		\
> +	func = (typeof(func))(unsigned long)(table + off);		\
> +	c->text_output = *func;						\

Since you are macroizing this anyway, do you notice how often this
particular stanza or some variant thereof is repeated?  It really seems
like it should make a good macro and make the code a lot more readable.

That being said, is there a reason we can't simply write this as:

	efi_system_table_##bits##_t table;

	/* ... */

	func = (typeof(func))(unsigned long)table->con_out;
	c->text_output = *func;

	(which could still be turned into a macro perhaps?)

	-hpa
