From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Sat, 3 Oct 2015 11:05:39 +0200
Message-ID: <20151003090539.GC11942@pd.tnic>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
 <20151002173704.GD16538@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8641E4@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A8641E4@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 03, 2015 at 03:18:41AM +0000, Kweh, Hock Leong wrote:
> > What does the error case look like? A standard glibc message about
> > write(2) failing?
> > 
> 
> Any upload fail error like -ENOMEM, -EINVAL, -EIO as well as error returned
> by efi_capsule_update() API.

All I'm asking is, how does the user know that the upload didn't succeed?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
