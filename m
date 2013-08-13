From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 03/16] Rename memory allocation/free functions
Date: Tue, 13 Aug 2013 09:56:49 -0400
Message-ID: <1376402209.27484.14.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-4-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1376090777-20090-4-git-send-email-roy.franz@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-efi@vger.kernel.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, matt.fleming@intel.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Rename them to be more similar, as low_free() could be used to free
> memory allocated by both high_alloc() and low_alloc().
> high_alloc() -> efi_high_alloc()
> low_alloc()  -> efi_low_alloc()
> low_free()   -> efi_free()
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>
