From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Thu, 2 Mar 2017 08:38:51 -0600
Message-ID: <e170874b-2af7-b594-a804-c089e75b7e25@codeaurora.org>
References: <1486502360-18071-1-git-send-email-jhugo@codeaurora.org>
 <20170224153644.GE417@leverpostej> <20170302102328.GB1746@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170302102328.GB1746@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Jeffrey Hugo <jhugo@codeaurora.org>, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, Sameer Goel <sgoel@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

AKASHI Takahiro wrote:
> Since the values of *-cells under root node should reflect the hardware,
> the kernel has no way to determine whether they be 1 or 2 here.

It's safe to set the *-cells to 2 on all platforms, as long as everyone who 
reads/writes from/to the device tree respects those values (which is what 
they're supposed to do anyway).

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
