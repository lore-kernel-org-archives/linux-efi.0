From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/5] efi: introduce efi_md_typeattr_format()
Date: Wed, 3 Sep 2014 13:46:13 +0100
Message-ID: <20140903124613.GD3001@console-pimps.org>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
 <1409532820-5027-3-git-send-email-lersek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1409532820-5027-3-git-send-email-lersek@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Laszlo Ersek <lersek@redhat.com>
Cc: matt.fleming@intel.com, linux-ia64@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, msalter@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Mon, 01 Sep, at 02:53:37AM, Laszlo Ersek wrote:
> +char * __init efi_md_typeattr_format(char *buf, size_t size,
> +				     const efi_memory_desc_t *md)
> +{
> +	char *pos;
> +	int type_len;
> +	register u64 attr;

You can delete the 'register' keyword, since the compiler is free to
ignore it (and will do so).

Rest of the patch looks good.

-- 
Matt Fleming, Intel Open Source Technology Center
