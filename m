From: Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs
 and dma changed
Date: Mon, 28 Nov 2016 16:32:19 -0600
Message-ID: <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org>
References: <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
 <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <26173.1479769852@warthog.procyon.org.uk>
Reply-To: minyard-HInyCGIudOg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26173.1479769852-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/21/2016 05:10 PM, David Howells wrote:
> One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:
>
>> You need to filter or lock down kernel module options because a lot of
>> modules let you set the I/O port or similar (eg mmio) which means you can
>> hack the entire machine with say the 8250 driver just by using it with an
>> mmio of the right location to patch the secure state to zero just by
>> getting the ability to write to the modules conf file.
> Is the attached patch the right sort of idea?  [Note that I haven't actually
> compiled most of these drivers to check my changes yet.]
>
> David
> ---

snip

> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index a112c0146012..7fb9c299a183 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3725,6 +3725,12 @@ static int init_ipmi_si(void)
>   	struct smi_info *e;
>   	enum ipmi_addr_src type = SI_INVALID;
>   
> +	if ((num_addrs || num_ports || num_irqs) &&
> +	    kernel_is_locked_down()) {
> +		pr_err(PFX "Kernel is locked down\n");
> +		return -EPERM;
> +	}
> +
>   	if (initialized)
>   		return 0;
>   	initialized = 1;

This would prevent any IPMI interface from working if any address was given
on the kernel command line. I'm not sure what the best policy is, but that
sounds like a possible DOS to me.

Can you put this check in hardcode_find_bmc()?  Thats the only place where
the hardcoded addresses are used, and a check there won't affect anything
else.

Also, the error message sounds a little vague to me.  If I was a sysadmin
and got this, I wouldn't be sure what was going on.  Maybe something like:
The kernel is locked down, but hard-coded device addresses were given on
the driver command line.  Ignoring these, but this is a possible 
security issue.

That's fairly wordy, but it gets the point across.  You could also move the
pr_err() into kernel_is_locked_down() and pass in the prefix, since there is
basically the same pr_err() after every check.

Thanks,

-corey
