From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:17:33 +0000
Message-ID: <20121031171733.0ff2a976@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
	<20121031170334.59833fb1@pyramind.ukuu.org.uk>
	<50915975.8030503@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <50915975.8030503@shealevy.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Shea Levy <shea@shealevy.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

> >> Prepare (as a root) a hand-crafted image, reboot, let the kernel resume
> >> from that artificial image.
> > It's not signed. It won't reboot from that image.
> 
> So then to hibernate the kernel must have a signing key?

No.

If you break the kernel so you can patch swap we already lost.

If you add a new bootable image and reboot your image won't boot anyway

If you've got physical access you've already won

So you can't break the swap image before hibernation. You can't boot
something else to tamper with it and you've not got physical access.
