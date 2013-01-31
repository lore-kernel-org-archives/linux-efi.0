From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: efivarfs allows non-canonical GUID and duplicate filenames
Date: Thu, 31 Jan 2013 19:52:17 +0000
Message-ID: <1359661937.7515.44.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <51022DD7.4010701@redhat.com> <20130129044418.GD14395@srcf.ucam.org>
	 <51075B56.5050408@redhat.com> <20130129052532.GA15383@srcf.ucam.org>
	 <51076220.5080001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51076220.5080001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-01-29 at 13:46 +0800, Lingzhu Xiang wrote:
> So I create a file with upper case GUID string, but the upper and lower case
> are parsed to be the same binary value and saved separately in sysfs. During
> remount, the binary GUID is formatted to lower case, so the upper and lower
> case sysfs entries come back to efivarfs with the same name.
> 
> This is just trying to explore the impact of not having GUID validation for
> filename. Not something new.

There are two problems with the way filenames are validated currently.
We don't validate the GUID portion at all, which was demonstrated when
you created a file in efivarfs with a filename of,

	test-------------------------------------

Also, we're using the simple dentry operations which has a
case-sensitive d_compare. While the first portion of the filename, the
variable name, is case-sensitive, the GUID part isn't. And that's the
bug that allowed you to create two files with the same GUID, one
uppercase, one lowercase.

I'll take a look at fixing this. Thanks for the report.

-- 
Matt Fleming, Intel Open Source Technology Center
