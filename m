From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Tue, 19 Mar 2013 18:02:53 -0700
Message-ID: <51490ABD.3050205@zytor.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 02:32 PM, Matthew Garrett wrote:
> 
> This means we can return our focus to the kernel. There's currently a number
> of kernel interfaces that permit privileged userspace to modify the running
> kernel. These are currently protected by CAP_SYS_RAWIO, but unfortunately
> the semantics of this capability are poorly defined and it now covers a large
> superset of the desired behaviour.
> 

... except it doesn't.

Looking at it in detail, EVERYTHING in CAP_SYS_RAWIO has the possibility
of compromising the kernel, because they let device drivers be bypassed,
which means arbitrary DMA, which means you have everything.

Now, a lot of the abuses of CAP_SYS_RAWIO have clearly been added by
people who had *no bloody clue* what that capability meant, but it
really doesn't change the fact that pretty much if you have
CAP_SYS_RAWIO you have the machine.

So just reject CAP_SYS_RAWIO.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

