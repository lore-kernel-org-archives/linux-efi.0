From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Sat, 3 Oct 2015 11:08:29 +0200
Message-ID: <20151003090829.GD11942@pd.tnic>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
 <20151002173704.GD16538@pd.tnic>
 <CALCETrVB_QbG3Se2YHqUQx2SiZBrsNw95wRJrtLtFPJmxn_svA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVB_QbG3Se2YHqUQx2SiZBrsNw95wRJrtLtFPJmxn_svA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, Roy Franz <roy.franz@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ong Boon Leong <boon.leong.ong@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sam Protsenko <semen.protsenko@linaro.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>, LKML <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 02, 2015 at 09:18:05PM -0700, Andy Lutomirski wrote:
> > What does the error case look like? A standard glibc message about
> > write(2) failing?
> >
> 
> close(2), right?

I'm looking at those retvals of efi_capsule_write(). They are returned
to userspace during write(2), no?

/me has no idea how the whole plumbing actually works that's why me is
asking stupid questions.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
