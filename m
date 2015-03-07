From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Sat, 7 Mar 2015 21:56:20 +0100
Message-ID: <20150307205620.GB3380@pd.tnic>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-5-git-send-email-yinghai@kernel.org>
 <20150304101649.GA3663@pd.tnic>
 <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
 <20150304200000.GB6276@gmail.com>
 <CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
 <20150306133312.GC4259@pd.tnic>
 <CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 06, 2015 at 11:50:54AM -0800, Yinghai Lu wrote:
> On Fri, Mar 6, 2015 at 5:33 AM, Borislav Petkov <bp@suse.de> wrote:
> 
> >
> > "However, the setup_data linked list and thus the element which contains
> > kaslr_enabled is chained together using physical addresses. At the
> > time when we access it in the kernel proper, we're already running
> > with paging enabled and therefore must access it through its virtual
> > address."
> >
> > That's it, now how hard was to explain it that way?
> 
> No, I don't think your change log is right.
> 
> Actually the old code is using address as value.

Am I saying something about using a physical address as value above? Or
you can't read now either?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
