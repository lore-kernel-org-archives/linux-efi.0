From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Tue, 19 Mar 2013 18:03:50 -0700
Message-ID: <51490AF6.4080707@zytor.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
Sender: linux-pci-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 09:47 PM, James Morris wrote:
> On Mon, 18 Mar 2013, Matthew Garrett wrote:
> 
>> This patch introduces CAP_COMPROMISE_KERNEL. 
> 
> I'd like to see this named CAP_MODIFY_KERNEL, which is more accurate and 
> less emotive.  Otherwise I think core kernel developers will be scratching 
> their head over where to sprinkle this.
> 
> Apart from that, I like the idea, especially when it's wired up to MAC 
> security.

The wiring up to MAC security is a nice touch.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
