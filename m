From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 01/16] Move common EFI stub code from x86 arch code to
 common location
Date: Tue, 13 Aug 2013 09:56:20 -0400
Message-ID: <1376402180.27484.12.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-2-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376090777-20090-2-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> No code changes made, just moving functions from x86 arch directory
> to common location.
> Code is shared using #include, similar to how decompression code
> is shared among architectures.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>
