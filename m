From: Peter Jones <pjones@redhat.com>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 10 Mar 2015 11:21:55 -0400
Message-ID: <20150310152155.GB1208@fenchurch.internal.datastacks.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com>
 <20150310122652.GA17573@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150310122652.GA17573@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Andy Lutomirski <luto@amacapital.net>, Sam Protsenko <semen.protsenko@linaro.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 12:26:52PM +0000, Matt Fleming wrote:
> On Fri, 06 Mar, at 04:39:12PM, Peter Jones wrote:
> > 
> > So again: do we really need or want to do this?
> 
> One thing that we totally lose the ability to do is use the capsule
> interface for things *other* than firmware updates, e.g.
> 
>  https://lkml.org/lkml/2013/10/16/327 
> 
> Also, requiring embedded or custom OS to include fwupdate into their
> existing boot solutions is a bit heavy handed when literally all they
> want to do is cat a binary blob to a sysfs file.
> 
> I don't see why we can't have both solutions.

Yeah - we clearly need a kernel interface for some embedded devices, and
it'd be better for every vendor to not implement it themselves.

> Another thing is that ESRT isn't going to be supported by every
> platform.

Yeah - though I think you're *mostly* talking about the same platforms
as above.

> So, for the sysfs interface, let's not allow loading from /lib. Let's
> not require a userland tool. Let's just do,
> 
>   # echo /path/to/my/awesome/capsule.bin > /sys/../capsule

> 
> and be done with it.
> 
> Hmmm?

I assume you're implying a) the capsule header with the guid is embedded
in the .bin there already, and b) one contiguous write(2) with error
reporting coming through something like vars.c's efi_status_to_err()?

If so, yes, I prefer this API.

-- 
        Peter
