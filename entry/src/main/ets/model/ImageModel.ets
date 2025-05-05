export class ImageModel {
  id: number;
  imageUrl: string;
  deleteUrl: string;

  constructor(id: number, imageUrl: string, deleteUrl: string = '') {
    this.id = id;
    this.imageUrl = imageUrl;
    this.deleteUrl = deleteUrl;
  }
} 