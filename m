From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: runtime-wrappers: run UEFI Runtime Services with
 interrupts enabled
Date: Thu, 11 Feb 2016 16:03:54 +0000
Message-ID: <20160211160354.GJ4134@codeblueprint.co.uk>
References: <20160203105851.GA22159@gmail.com>
 <1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
 <CALCETrWWLGjqXmPKs7wF3uJ+jR-xctU0eYOESdVxMm5b4w8JMw@mail.gmail.com>
 <CAKv+Gu_sPq9wesOpEREyopVddpVW2P7m8YCDHHcBHkLk-kH+ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_sPq9wesOpEREyopVddpVW2P7m8YCDHHcBHkLk-kH+ew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

On Tue, 09 Feb, at 05:52:34PM, Ard Biesheuvel wrote:
> On 8 February 2016 at 20:37, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Feb 4, 2016 5:58 AM, "Ard Biesheuvel" <ard.biesheuvel@linaro.org> wrote:
> >>
> >> OK, since Sai has confirmed that Windows leaves interrupts enabled when
> >> calling the EFI variable store related runtime services, we should be able
> >> to do the same for Linux, or at least be slightly more confident that we
> >> won't have to back out this change later.
> >
> > Could this use a mutex instead of a spinlock?
> >
> 
> When I first started working on this code, I proposed using a mutex,
> but at the time, we still had the efi-pstore case to worry about
> http://article.gmane.org/gmane.linux.kernel.efi/4112
> 
> In the mean time, we have modified the efi-pstore code so it simply
> gives up when the EFI varstore is busy, and we also got rid of the NMI
> special case where locks are ignored. In summary, it sounds to me that
> moving to a mutex should be feasible, but I am only really familiar
> with the ARM side of the implementation, which is far less complex
> than the x86 side, so Matt should confirm.

You cannot touch mutexes from interrupt context, not even to perform a
mutex_trylock(), and that's the problem.

Since the efi-pstore code can run from interrupt context we need to
use a locking primitive that works, even though we have all that
non-blocking logic. 
