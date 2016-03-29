From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH RFC 1/1] x86: fix bad memory access in
 fb_is_primary_device()
Date: Tue, 29 Mar 2016 12:53:47 +0100
Message-ID: <20160329115347.GA3625@codeblueprint.co.uk>
References: <1455528649-26629-1-git-send-email-alpopov@ptsecurity.com>
 <20160216075521.GA27491@gmail.com>
 <20160216134918.GD2769@codeblueprint.co.uk>
 <20160216151859.GB11373@redhat.com>
 <56E01B0F.3000306@ptsecurity.com>
 <56F52111.6050500@ptsecurity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56F52111.6050500@ptsecurity.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Popov <alpopov@ptsecurity.com>
Cc: Peter Jones <pjones@redhat.com>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 25 Mar, at 02:29:21PM, Alexander Popov wrote:
> 
> Excuse me, there is no reply for a long time. Did I touch any taboo topic?
> Hope to fix this bug. Thanks.

Unless anyone complains soonish I'll send this to tip as part of the
EFI urgent queue.
