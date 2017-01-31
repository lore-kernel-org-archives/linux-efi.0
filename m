From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] efi: Get the secure boot status [ver #7]
Date: Tue, 31 Jan 2017 20:18:16 +0000
Message-ID: <CAKv+Gu_oUcbQ9CYLTentjoHWreVX7Y2-SN5BBcxZ_g4-pNG1yw@mail.gmail.com>
References: <148587562967.4026.18171897997650345605.stgit@warthog.procyon.org.uk>
 <201702010101.EljWXBuB%fengguang.wu@intel.com> <CAKv+Gu92yTWcEguxGzMOQAvoUexCLtsVVBa2Xzz3cPPWQD9nSQ@mail.gmail.com>
 <10308.1485888776@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10308.1485888776-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 January 2017 at 18:52, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
>>
>> This is the wrong repo ^^^
>>
>> I am not sure if there is anything we can do about this, but perhaps
>> you should simply remove it now that we've migrated to the new repo.
>
> Is the error a derivative of the rebase?  I'm sure this was working in the
> un-rebased code.
>

Well, indirectly. The kbuild robot is applying the patches onto an
outdated EFI branch owned by Matt, rather than the official one which
has my patch that turns the runtime services struct from a collection
of pointers to void into properly typed function pointers.
