From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Tue, 22 Nov 2016 21:36:31 +0100
Message-ID: <20161122203631.GB1844@wunner.de>
References: <20161122104401.GC1552@wunner.de>
 <20161117123731.GA11573@wunner.de>
 <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk>
 <25371.1479826321@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25371.1479826321-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 22, 2016 at 02:52:01PM +0000, David Howells wrote:
> Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > You dropped the efi_system_table_t *sys_table_arg argument but this
> > isn't defined anywhere as a static global.
> 
> It seems to me that passing this value in on x86 is probably a bad idea as
> it's not mixed-mode safe.  Should I just pass NULL there in that case?

It's safe, it's merely a pointer below 4 Gig.  Just on dereference it
needs to be cast to the correct variant.  Passing in sys_table_arg is
done all over the place in the EFI stub, see e.g. efi_printk().

Best regards,

Lukas
