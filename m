From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 04/20] x86: Secure Memory Encryption (SME) support
Date: Tue, 30 Aug 2016 07:57:25 -0700
Message-ID: <CALCETrVoiM3bskfWrg4c8ttHr467Us9xdXuxw=T6Dkr0PFo18g@mail.gmail.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
 <20160822223610.29880.21739.stgit@tlendack-t1.amdoffice.net>
 <alpine.DEB.2.20.1608251503340.5714@nanos> <e296f12d-7c76-4690-17bd-0f721d739f07@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e296f12d-7c76-4690-17bd-0f721d739f07-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joerg
List-Id: linux-efi@vger.kernel.org

On Aug 30, 2016 6:34 AM, "Tom Lendacky" <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
>
> On 08/25/2016 08:04 AM, Thomas Gleixner wrote:
> > On Mon, 22 Aug 2016, Tom Lendacky wrote:
> >
> >> Provide support for Secure Memory Encryption (SME). This initial support
> >> defines the memory encryption mask as a variable for quick access and an
> >> accessor for retrieving the number of physical addressing bits lost if
> >> SME is enabled.
> >
> > What is the reason that this needs to live in assembly code?
>
> In later patches this code is expanded and deals with a lot of page
> table manipulation, cpuid/rdmsr instructions, etc. and so I thought it
> was best to do it this way.

None of that sounds like it needs to be in asm, though.

I, at least, have a strong preference for minimizing the amount of asm
in the low-level arch code.

--Andy
