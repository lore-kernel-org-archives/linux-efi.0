From: Pankaj Bansal <pankaj.bansal@nxp.com>
Subject: [edk2] Uefi runtime property in device tree
Date: Wed, 26 Dec 2018 10:17:35 +0000
Message-ID: <HE1PR0402MB332391A3363235543F068957F1B50@HE1PR0402MB3323.eurprd04.prod.outlook.com>
References: <HE1PR0402MB33233B2625F8D7EFF08C4994F1B50@HE1PR0402MB3323.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.01.org>
In-Reply-To: <HE1PR0402MB33233B2625F8D7EFF08C4994F1B50@HE1PR0402MB3323.eurprd04.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/edk2-devel/>
List-Post: <mailto:edk2-devel@lists.01.org>
List-Help: <mailto:edk2-devel-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.01.org
Sender: "edk2-devel" <edk2-devel-bounces@lists.01.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hello Ard et al.

I have a query regarding the device tree usage in UEFI.
In our UEFI implementation for NXP SOCs, we are using device tree to detect Non discoverable platform devices.
Based on the device detected in device tree, a device instance is created and the device's driver binds to that device's handle (a DXE driver or an UEFI driver).
if the device were to be used for runtime service, then we need to allocate the memory for that device instance from runtime pool and set its virtual address using EfiConvertPointer.
To facilitate this, I wish to add an optional property to the device node "uefi-runtime".
If this property is present in device tree the UEFI firmware will allocate the data from runtime pool for this device.
Also firmware will disable/delete the node in device tree before passing onto OS, so that OS doesn't use the device.

I wish to know your thoughts on this. If this doesn't seem the right way, I am happy to hear your suggestions.

Thanks & Regards,
Pankaj Bansal
