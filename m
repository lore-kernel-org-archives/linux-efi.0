From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 08 Feb 2013 15:09:19 -0800
Message-ID: <5115859F.8070805@amacapital.net>
References: <20130208191213.GA25081@www.outflux.net> <00780235-deac-4f80-b936-867834e05661@email.android.com> <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com> <5115553A.5000708@zytor.com> <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com> <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com> <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com> <1360355671.18083.18.camel@x230.lan> <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com> <1360357636.18083.19.camel@x230.lan> <CA+5PVA4EbgBRgg+ZDa4+vG0Ngw8wJ3kH6NcmDvZ=+CP=kH82_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+5PVA4EbgBRgg+ZDa4+vG0Ngw8wJ3kH6NcmDvZ=+CP=kH82_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jwboyer@gmail.com
Cc: Matthew Garrett <mjg@redhat.com>, Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 02/08/2013 01:14 PM, Josh Boyer wrote:
> On Fri, Feb 8, 2013 at 4:07 PM, Matthew Garrett
> <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, 2013-02-08 at 13:02 -0800, Kees Cook wrote:
>>
>>> I don't find it unreasonable to drop all caps and lose access to
>>> sensitive things. :) That's sort of the point, really. I think a cap
>>> is the best match. It seems like it should either be a cap or a
>>> namespace flag, but the latter seems messy.
>>
>> Yeah, I think it's an expected outcome, but it means that if (say) qemu
>> drops privileges, qemu can no longer access PCI resources - even on
>> non-secure boot systems. That breaks existing userspace.
> 
> Right.  We've had a few reports in Fedora of things breaking on non-SB
> systems because of this.  The qemu one is the latest, but the general
> problem is people think dropping all caps blindly is making their apps
> safer.  Then they find they can't do things they could do before the new
> cap was added.  It's messy.

Why not require CAP_COMPROMISE_KERNEL to open (with O_RDWR or O_WRONLY)
/dev/msr?  After all, sudo </dev/null >/dev/msr will cause a privileged
write() call on the fd as long as the capability is in your bounding set.

--Andy
