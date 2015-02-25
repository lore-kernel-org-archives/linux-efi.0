From: Borislav Petkov <bp@alien8.de>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Wed, 25 Feb 2015 13:49:23 +0100
Message-ID: <20150225124923.GE3226@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150225114747.GC3226@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C2B8ACE92@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8ACE92@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Sam Protsenko <semen.protsenko@linaro.org>, Matt Fleming <matt@console-pimps.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 25, 2015 at 12:38:20PM +0000, Kweh, Hock Leong wrote:
> The reason we use this interface for efi capsule is that efi capsule
> support multi binaries to be uploaded and each binary file name
> can be different.

So you can write the file path to a second file and reload then, once
per file.

Alternatively, you can combine all the files into a cpio archive like
we do with the microcode loader too, and let the kernel parse the cpio
archive.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
