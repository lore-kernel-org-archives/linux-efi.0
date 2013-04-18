From: leosilva <leosilva-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: EFI phys_prelog, run a physical address directly in kernel space
 with efi api.
Date: Thu, 18 Apr 2013 15:15:01 -0300
Message-ID: <1366308901.14115.16.camel@lain-ibm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

I'm faced with that issue where I have a physical address that was
mapped by EFI memap (I did check it using efi_lookup_mapped_addr). It is
not or an EFI run time services neither an EFI boot service. 
In my attempts I was able to map the physical address to a virtual in
Kernel space, but when I try call it using some __inline__ asm, I
realized that into this function (pointed by the physical address I
mapped),it tries to do an access to another physical address and I grab
an oops: 'unable to access the page in the address.'

Now I'm supposing I need to run that physical address function directly
without map it to virtual space and seems that the way to do it is using
some EFI API. In short I'm thinking in run that code in physical space
(something like real mode). I took a look in efi_phys_prelog
and ..epilog to do that. But I was surprised with a long stack trace
that point me to a oops: 'schedule while atomic'.

So, I'd like to know if is there anyway to do it using EFI API that we
have in kernel (arch x86_64)?


-- 
leosilva <leosilva-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
