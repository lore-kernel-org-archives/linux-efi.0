From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Apple device properties
Date: Sat, 12 Nov 2016 10:10:04 +0000
Message-ID: <20161112101004.GI8845@codeblueprint.co.uk>
References: <cover.1478506920.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1478506920.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 07 Nov, at 11:09:00AM, Lukas Wunner wrote:
> Retrieve device properties from EFI on Macs before ExitBootServices is
> called and assign them to devices (patch [3/4]). The devices that
> properties pertain to are encoded as EFI Device Paths, so add a parser
> for these (patch [1/4]). As a first use case, amend the Thunderbolt driver
> to take advantage of the Device ROM supplied by EFI (patch [4/4]).
 
Looks good to me Lukas. Queued for v4.10, thanks!
