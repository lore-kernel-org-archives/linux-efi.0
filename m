From: Joel Schopp <jschopp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: unusual uefi call/mapping problem
Date: Wed, 17 Apr 2013 00:04:16 -0500
Message-ID: <516E2D50.8030908@linux.vnet.ibm.com>
References: <516DC325.6090604@linux.vnet.ibm.com> <20130417024056.GA13609@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130417024056.GA13609-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leonidas da Silva Barbosa <leosilva-xuelUoVDAHHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Thanks for the quick reply.

>> I'm working on the Linux kernel implementation of an draft standard
>> that has a uefi component.
>
> What standard would that be?

Trusted Computing Group Dynamic Root of Trust Management (D-RTM).


>> After extracting the physical address of the UEFI service we can't
>> successfully map it or call it.
>
> You want to call it from the kernel?  Why?  Usually you get a "virtual"
> address to call UEFI things, and then use efi_call_virt?(), why can't
> you do that here as well?

If I had a virtual address I would be a happy man.  I have a physical 
address and my attempts to turn it into a virtual one that is callable 
have been unfruitful.


>> 2) Various methods to map in the physical address into virtual
>> address space and then call the virtual address.  All of these have
>> failed.
>
> Why?  What have you done that failed?  Any pointers to code anywhere?

Unfortunately I can't release code until after the spec is public.  I 
believe that will happen in a matter of weeks and not months.  Then all 
work will be shared under gpl and we will work on getting it functional 
and acceptable for upstream inclusion.  I realize not being able to post 
code now is very limiting.

>
> Are you trying to do this before we switch to virtual mode, or after?

After.  We are trying to do this well after all userspace has started.
