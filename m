From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/efivarfs: Add create-read test
Date: Tue, 29 Jan 2013 20:18:28 +0000
Message-ID: <1359490708.8282.107.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359240460.11991.960193311372.3.gpush@pororo>
	  <5106603C.5050309@redhat.com>
	 <1359376629.8282.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5106FE77.3030001@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5106FE77.3030001-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-01-29 at 07:40 +0900, Jeremy Kerr wrote:
> Hi all,
> 
> >> Empty variable never exists in nvram per spec. Userspace doesn't need an
> >> extra
> >> EIO to figure out this known fact. In the meantime, user would wonder if
> >> something else has gone wrong? Returning zero for reading an empty file can
> >> reserve EIO for something more informational.
> >
> > Perhaps it's not unreasonable to expect users to understand that
> > zero-length files don't have a corresponding EFI variable, and that the
> > file won't persist across a reboot.
> >
> > Jeremy, thoughts?
> 
> I think that EOF would be better; it's not really an "error" condition, 
> just that no data has been given yet.

Works for me.

> I'd be happy to change this check to suit.

That would be great, thank you.

-- 
Matt Fleming, Intel Open Source Technology Center
