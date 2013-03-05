From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Tue, 05 Mar 2013 17:39:50 +0800
Message-ID: <5135BD66.1030005@redhat.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/03/2013 02:03 AM, Andre Heider wrote:
> After a BIOS update I get this in dmesg:
> 
> [    0.581554] EFI Variables Facility v0.08 2004-May-17
> [    0.584914] ------------[ cut here ]------------
> [    0.585639] WARNING: at /home/andre/linux/fs/sysfs/dir.c:536 sysfs_add_one+0x
> d4/0x100()
> [    0.586381] Hardware name: To be filled by O.E.M.
> [    0.587123] sysfs: cannot create duplicate filename '/firmware/efi/vars/SbAsl
> BufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8'
> (snip)
> 
> Sounds like yet another BIOS issue, and I guess the answer is
> "complain to the manufacturer"... But we know how well that works, so
> can this be a warning instead of a scary backtrace? :)
> 
> (this is: Gigabyte Technology Co., Ltd. To be filled by
> O.E.M./Z77X-UD3H, BIOS F19e 11/21/2012)"

Just saw https://bugzilla.kernel.org/show_bug.cgi?id=47631

I think this problem is getting more and more common.

I had an IBM System x3100 M4 and x3850 X5 on which kernel would get stuck
in infinite loop creating duplicate sysfs files because, for some reason,
there are several duplicate boot entries in nvram getting GetNextVariableName
into a circle of iteration (with period > 2).

Granted, it's not kernel's fault for duplicate variables, but it'd be much
harder for users to fix their broken firmware than kernel dealing with it
by not dying on the never-ending GetNextVariableName.


Lingzhu Xiang
