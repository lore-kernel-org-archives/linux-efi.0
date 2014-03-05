From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] efi: cper: Support different length of Error Section
Date: Tue, 4 Mar 2014 16:38:49 -0800
Message-ID: <CA+8MBbL2K0=5rY3hZqC23ap9tWet3GUz-RwB4Z0qPLQm8LipNQ@mail.gmail.com>
References: <6366A95FCFBB78419E783DDD020ED2ECB2E9EC@APMAILMBX03.lenovo.com>
	<20140304234145.GB17362@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140304234145.GB17362-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Adrian Huang12 <ahuang12-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 4, 2014 at 3:41 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>> Tested on v3.14-rc5 with Grantley platform and Intel RAStool.

So - I've been playing with Grantley too - and didn't see these warnings about
"error length section too small".  I suspect this is because I've been
toggling the
BIOS option under:

   EDKII > Advanced > System Event Log > WHEA Settings > UEFI Version

to request reports according to spec version 2.3.1 (to get the card handle and
module handle fields)

Does that fit with your experience too?

-Tony

[I note that there is a 2.4 version of UEFI ... are there more changes to the
error record format there?  I know there are plans to tweak even more
bits because
some of the 2-byte fields in the memory error description are not big enough
to describe locations on 64GB DIMMs]
