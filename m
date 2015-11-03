From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v9 1/1] efi: a misc char interface for user to update efi
 firmware
Date: Tue, 3 Nov 2015 21:14:55 +0100
Message-ID: <20151103201455.GD3620@pd.tnic>
References: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
 <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
 <20151101102944.GA12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8799FB@PGSMSX102.gar.corp.intel.com>
 <20151101105801.GB12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A879A18@PGSMSX102.gar.corp.intel.com>
 <20151101125835.GC12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A879C38@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A879C38@PGSMSX102.gar.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 02, 2015 at 07:17:28AM +0000, Kweh, Hock Leong wrote:
> This is not a return value to indicate what is going now. It is a flag
> used in "cap_info->index" which positive value has a meaning of index
> number. I am using the negative value for the flag which similar to
> the implementation of pointer & error pointer (ERR_PTR).

Ok, but that doesn't make any sense: you're assigning UPLOAD_DONE to
cap_info->index only once in efi_capsule_submit_update() and you're not
testing it anywhere. Yeah, yeah, you're implicitly testing for it by
doing the "< 0" check.

So simply assign -1 to ->index to mean *any* type of error occurred,
remove the defines and you can always test for "< 0" to mean "did
something fail".

You simply don't need two error values...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
