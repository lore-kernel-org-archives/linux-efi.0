From: fupan <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 3.10 ~ 3.14] efi: fix the efi 32bit boot failed problem
Date: Mon, 3 Aug 2015 09:38:23 +0800
Message-ID: <55BEC60F.1040404@windriver.com>
References: <1438078879-24705-1-git-send-email-fupan.li@windriver.com> <20150730150428.GJ2725@codeblueprint.co.uk> <20150730163102.GA19943@kroah.com> <20150730164544.GL2725@codeblueprint.co.uk> <20150730165943.GD5515@kroah.com> <55BACDD9.6020505@windriver.com> <20150731120519.GN2725@codeblueprint.co.uk> <20150731122150.GB2626@ares>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731122150.GB2626@ares>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luis Henriques <luis.henriques-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/31/2015 08:21 PM, Luis Henriques wrote:
> On Fri, Jul 31, 2015 at 01:05:19PM +0100, Matt Fleming wrote:
>> On Fri, 31 Jul, at 09:22:33AM, fupan wrote:
>>> Hi, Matt
>>>
>>> Will you take care of this patch or I send a V2?
>>  =20
>> Could you please send a V2 with the changes to the commit message th=
at I
>> suggested previously? Thanks!
>>
> I'm replying to this thread simply to include Jiri on the CC list as =
I
> believe 3.12 will also require this fix.  Please make sure he's in th=
e
> list for the v2.
Hi, Lu=EDs

No problem.

BTW, actually all of the branch from 3.10 to 3.14 will need this fix.

=46upan
>
> [ It looks like the 3.16 kernel I'm maintaining isn't affected, BTW. =
]
>
> Cheers,
> --
> Lu=EDs
>
>
