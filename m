From: Matt Fleming <matt@console-pimps.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Mon, 2 Mar 2015 11:24:20 +0000
Message-ID: <20150302112420.GA24476@codeblueprint.co.uk>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150225114747.GC3226@pd.tnic>
 <CALCETrVk8GJSzOyRu3Jr-72Tp79XzunGg9T-_70ngTPnG4YZqQ@mail.gmail.com>
 <20150226155458.GC3314@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150226155458.GC3314@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Sam Protsenko <semen.protsenko@linaro.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Feb, at 04:54:58PM, Borislav Petkov wrote:
> On Thu, Feb 26, 2015 at 07:30:54AM -0800, Andy Lutomirski wrote:
> > How can the error code be propagated?  Would that echo command fail in
> > case of error?
> 
> Yeah, either that or we can put the error code in the sysfs file which
> userspace can cat.

FWIW, I'd prefer to make the echo command fail in case of capsule error.

-- 
Matt Fleming, Intel Open Source Technology Center
