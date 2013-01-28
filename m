From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/efivarfs: Add create-read test
Date: Mon, 28 Jan 2013 12:37:09 +0000
Message-ID: <1359376629.8282.18.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359240460.11991.960193311372.3.gpush@pororo>
	 <5106603C.5050309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5106603C.5050309-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-01-28 at 19:25 +0800, Lingzhu Xiang wrote:
> On 01/27/2013 06:47 AM, Jeremy Kerr wrote:
> > +	if (!(rc < 0 && errno == EIO)) {
> > +		fprintf(stderr, "Reading a new var should return -EIO\n");
> 
> What does the -EIO imply for reading a known empty file?
> 
> The file is empty. There is nothing to be read. No IO should actually 
> happens.
> The variable doesn't exist in nvram. What is the error? This won't make 
> sense
> for userspace.

I was the one who originally suggested using EIO for reading a variable
that hasn't hit the backing store, mainly because it simplified the
EFI_NOT_FOUND logic, and I felt that reading from a non-existent
variable should be an error condition. But I can see the case for
returning zero instead.

> Empty variable never exists in nvram per spec. Userspace doesn't need an 
> extra
> EIO to figure out this known fact. In the meantime, user would wonder if
> something else has gone wrong? Returning zero for reading an empty file can
> reserve EIO for something more informational.

Perhaps it's not unreasonable to expect users to understand that
zero-length files don't have a corresponding EFI variable, and that the
file won't persist across a reboot.

Jeremy, thoughts?

> Maybe at this time we just leave it as it is for other reasons. But at least
> I don't think it's a good idea to mandate this behavior.

I do think it's important that we hash out these semantics as soon as
possible, before userspace starts relying on them.

-- 
Matt Fleming, Intel Open Source Technology Center
