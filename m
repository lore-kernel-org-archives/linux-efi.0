From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: Add device path parser
Date: Tue, 25 Oct 2016 13:44:06 +0100
Message-ID: <20161025124406.GD20387@codeblueprint.co.uk>
References: <cover.1476698603.git.lukas@wunner.de>
 <ece9b12b1d0b86c83e8369e4123fc7bc60db1fdc.1476698603.git.lukas@wunner.de>
 <20161019111728.GC31476@codeblueprint.co.uk>
 <20161019115119.GA2973@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161019115119.GA2973-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 19 Oct, at 01:51:19PM, Lukas Wunner wrote:
> > Where in your patch series is this function called? Am I missing
> > something?
> 
> This is called by unmarshal_devices() in patch [2/3] of this series.
 
Where is PATCH 2? I can't find it in my inbox or on linux-efi.

> > Also, unless there's some existing namespace with "get_device_by_*"
> > I'd prefer for this function name to have "efi_" as the prefix.
> 
> There's get_device() defined in include/linux/device.h which returns a
> reference to a device, this function here is basically named after it
> because it likewise returns a reference.
> 
> How about efi_get_device_by_path()?

That'd be great, thanks!
