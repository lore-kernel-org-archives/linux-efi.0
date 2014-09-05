From: Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: oops on kernel 3.14.17 seems related to EFI
Date: Fri, 05 Sep 2014 14:33:30 +0200
Message-ID: <5409AD9A.4030206@gmail.com>
References: <54095D73.7010907@gmail.com> <20140905120904.GN3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140905120904.GN3001-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/05/2014 02:09 PM, Matt Fleming wrote:
> (Adding linux-efi)
> 
> On Fri, 05 Sep, at 08:51:31AM, Francis Moreau wrote:
>> [  +0.000045] RIP: 0010:[<0000000000000000>]  [<          (null)>]      (null)
>> [  +0.000046] RSP: 0018:ffff8800b4001da8  EFLAGS: 00010002
>> [  +0.000032] RAX: 0000000080050033 RBX: ffff880406288000 RCX: ffff880406288000
>> [  +0.000041] RDX: ffff880406288400 RSI: ffff880406288000 RDI: 0000000000000000
>> [  +0.000042] RBP: ffff8800b4001e80 R08: 0000000000000000 R09: ffff8800b4001ec0
>> [  +0.000042] R10: 0000000000000000 R11: 0000000000000246 R12: ffff880406288400
>> [  +0.000042] R13: 0000000000000000 R14: ffff8800b4001ec0 R15: 000000000009b000
>> [  +0.000042] FS:  00007f7720a567c0(0000) GS:ffff88041e2c0000(0000) knlGS:0000000000000000
>> [  +0.000048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  +0.000034] CR2: 0000000000000000 CR3: 000000000009b000 CR4: 00000000001427e0
>> [  +0.000042] Stack:
>> [  +0.000014]  ffffffff81063281 ffffffff811bd95c 0000000000000246 ffff8800da9e6628
>> [  +0.000052]  8000000300000000 0000000000000000 0000000000000000 ffff8800b4001e50
>> [  +0.000051]  0000000080050033 00007f7722abbc50 00007f7722abbb50 00ffffffffffffff
>> [  +0.000052] Call Trace:
>> [  +0.000022]  [<ffffffff81063281>] ? efi_call5+0x71/0xf0
>> [  +0.000035]  [<ffffffff811bd95c>] ? getname_flags+0x2c/0x130
>> [  +0.000037]  [<ffffffff81062649>] ? virt_efi_get_variable+0x49/0x60
>> [  +0.000051]  [<ffffffff813d0181>] efivar_entry_size+0x41/0x80
>> [  +0.000030]  [<ffffffff8123aec9>] efivarfs_file_read+0x49/0x100
>> [  +0.000046]  [<ffffffff811b2077>] vfs_read+0x97/0x160
>> [  +0.000041]  [<ffffffff811b2bc9>] SyS_read+0x59/0xd0
>> [  +0.000041]  [<ffffffff81509e29>] system_call_fastpath+0x16/0x1b
> 
> This looks like efi.systab->runtime->get_variable is NULL.
> 
> Could you send a copy of the dmesg buffer? It might contain some info to
> explain this issue.

Unfortunately, I haven't kept a copy of it.

> 
> Also, is this a regression? If so it would be excellent if you could
> pinpoint the commit that causes the problem, using git bisect.
> 

it's been a while now I'm stuck to 3.14 (later kernels oops for other
reasons) so I don't really remember. I would say no but I'm really not sure.

Thanks
