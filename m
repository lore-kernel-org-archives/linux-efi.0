From: "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
Date: Wed, 10 Jul 2013 12:39:40 +0100
Message-ID: <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
References: <51DD46AD.2010800@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51DD46AD.2010800@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 10 July 2013 12:34, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
> efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
> letting my macbook pro boot succesfully.

Thanks for the report. I'm going to queue up a revert of this patch,
Dave Young also reported a problem on his thinkpad.

> Is there anything I can do to help diagnose this issue?

Matthew?
