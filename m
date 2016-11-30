From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 30 Nov 2016 16:51:18 +0000
Message-ID: <31767.1480524678@warthog.procyon.org.uk>
References: <20161123104757.GE24624@leverpostej> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161123104757.GE24624@leverpostej>
Content-ID: <31766.1480524678.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:

> > +	boot_params->secure_boot = (efi_get_secureboot(sys_table) == 1);
> 
> In the arm stub's efi_entry(), we fail-safe, and assume secure boot for any
> non-zero status (including errors). e.g. 

Okay, given what Matthew said:

	A conforming implementation that supports secure boot should always
	return those variables without error. If they're not present (which is
	valid for x86 systems - many predate the feature) then assuming Secure
	Boot is disabled is correct. The question of what to do in the event
	of other errors is more open, but it wouldn't surprise me if there are
	implementations that return non-spec errors for missing variables
	under certain circumstances.

I think I have to assume the default to be that secure boot is *not* enabled
in the case of one of the variables we need to check is not being present.

As for getting other errors, I think we have to assume a buggy BIOS.  In this
case, I would also go with assuming we're not in secure boot.

Another possibility is to punt the decision and make it compile-time
configurable.

David
