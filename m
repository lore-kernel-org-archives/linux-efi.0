From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: Add device path parser
Date: Tue, 25 Oct 2016 15:51:06 +0200
Message-ID: <20161025135106.GA5908@wunner.de>
References: <cover.1476698603.git.lukas@wunner.de>
 <ece9b12b1d0b86c83e8369e4123fc7bc60db1fdc.1476698603.git.lukas@wunner.de>
 <20161019111728.GC31476@codeblueprint.co.uk>
 <20161019115119.GA2973@wunner.de>
 <20161025124406.GD20387@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161025124406.GD20387-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 25, 2016 at 01:44:06PM +0100, Matt Fleming wrote:
> On Wed, 19 Oct, at 01:51:19PM, Lukas Wunner wrote:
> > > Where in your patch series is this function called? Am I missing
> > > something?
> > 
> > This is called by unmarshal_devices() in patch [2/3] of this series.
>  
> Where is PATCH 2? I can't find it in my inbox or on linux-efi.

I notice you're using gmail, perhaps the message was classified as spam
due to its length (570 lines, 21 KByte)?  I definitely got the full series
back from vger.kernel.org as a subscriber to linux-efi@.

If all else fails, the patches can be viewed or fetched from GitHub:
https://github.com/l1k/linux/commits/apple_properties_v2

Direct link to patch [2/3]:
https://github.com/l1k/linux/commit/ac8b37bbe4b6

Thanks,

Lukas
