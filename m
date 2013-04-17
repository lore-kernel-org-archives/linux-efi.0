From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: unusual uefi call/mapping problem
Date: Tue, 16 Apr 2013 19:40:56 -0700
Message-ID: <20130417024056.GA13609@kroah.com>
References: <516DC325.6090604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <516DC325.6090604-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joel Schopp <jschopp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leonidas da Silva Barbosa <leosilva-xuelUoVDAHHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 16, 2013 at 04:31:17PM -0500, Joel Schopp wrote:
> I'm working on the Linux kernel implementation of an draft standard
> that has a uefi component.

What standard would that be?

> The interesting part is that the uefi
> component isn't in the uefi runtime table, but instead has a
> physical address stored an ACPI table.  Other than not being in the
> runtime table it behaves exactly like the other runtime services.
> 
> After extracting the physical address of the UEFI service we can't
> successfully map it or call it.

You want to call it from the kernel?  Why?  Usually you get a "virtual"
address to call UEFI things, and then use efi_call_virt?(), why can't
you do that here as well?

> I'm sure this is straightforward to
> somebody with experience in this area.  Here's a few of the things
> I've tried unsuccessfully, any pointers here would be appreciated.
> 
> 1) Call the physical address
> efi_call_phys_prelog();
> efi_call_phys5(...);
> efi_call_phys_epilog();
> 
> This generates some nasty scheduling while atomic errors

As it should :)

> 2) Various methods to map in the physical address into virtual
> address space and then call the virtual address.  All of these have
> failed.

Why?  What have you done that failed?  Any pointers to code anywhere?

Are you trying to do this before we switch to virtual mode, or after?

thanks,

greg k-h
