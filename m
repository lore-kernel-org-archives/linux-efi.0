From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Wed, 11 Feb 2015 11:29:58 -0500
Message-ID: <20150211162958.GA18062@fenchurch.internal.datastacks.com>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
 <20150209182742.GQ6461@codeblueprint.co.uk>
 <CAE9FiQUFO4yfEVgGZ9U0Q-RaokFor1gMbKJ7As2vvqGVkqrDbw@mail.gmail.com>
 <20150211155524.GC4665@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211155524.GC4665@codeblueprint.co.uk>
Sender: linux-doc-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 11, 2015 at 03:55:24PM +0000, Matt Fleming wrote:
> On Mon, 09 Feb, at 12:23:15PM, Yinghai Lu wrote:
> > On Mon, Feb 9, 2015 at 10:27 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> > > On Tue, 03 Feb, at 06:03:20PM, Yinghai Lu wrote:
> > >
> > > The first thing that comes to mind is the issues we experienced last
> > > year when adding support for loading initrds above 4GB to the EFI boot
> > > stub, c.f. commit 47226ad4f4cf ("x86/efi: Only load initrd above 4g on
> > > second try").
> > >
> > > Are things going to work correctly this time?
> > 
> > That should be addressed the grub2.
>  
> I vaguely remember thinking that the issue was only experienced when
> using the EFI_FILE protocol, which grub2 doesn't use. So the grub
> developers may be OK, but we should at least give them a heads up.

Looks correct to me.

> > I was thinking that we may need to add mem_limit command together with
> > linuxefi and initrdefi.
> > or add linuxefi64/initrdefi64?
>  
> No, we definitely do not want to add any more grub commands.

Definitely agree.

> > BTW, I tested loading kernel above grub2 on
> > virutalbox, qemu/kvm/OVMF, and real servers (ami ...) all work without problem.
> > 
> > wonder if we need have one black list for 64bit UEFI that does not
> > support access
> > memory above 4G.
>  
> We have been successful, so far, in not introducing these kind of
> blacklists. It would be a shame to start now.

>From grub's point of view I'm not sure why we'd care - the pages kernel
and initramfs land in are both from the Boot Services allocator, so if the
machine doesn't support high addresses, they won't be there.

-- 
        Peter
